package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabel;
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabeler;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.OnProgressListener;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;
import com.google.firebase.storage.UploadTask;
import com.squareup.picasso.Picasso;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

public class New_photo extends AppCompatActivity {
    ImageView photo, back;
    TextView location_view;
    Button share;
    EditText description, tag;
    private Uri mImageUri;
    private static final String TAG = "Image";
    private FusedLocationProviderClient fusedLocationClient;
    private String mLocation;
    private StorageTask mUploadTask;
    private StorageReference mStorageRef;
    private DatabaseReference mDatabaseRef;
    private ProgressBar mProgressBar;
    private String uid;
    private FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
    private String address;
    private String message;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_photo);

        photo = findViewById(R.id.photo);
        location_view = findViewById(R.id.location);
        share = findViewById(R.id.share);
        description = findViewById(R.id.description);
        tag = findViewById(R.id.tag);
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        mStorageRef = FirebaseStorage.getInstance().getReference("images");
        mDatabaseRef = FirebaseDatabase.getInstance().getReference("images");
        back = findViewById(R.id.back);

        back.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                finish();
            }
        });

        share.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                Intent intent = new Intent(getApplicationContext(), Log_in.class);
                startActivity(intent);
            }
        });

//        Log.d(TAG, "atest");

        uid = user.getUid();
        fusedLocationClient.getLastLocation()
                .addOnSuccessListener(this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            Log.d(TAG, "location: "+location);
                            double latitude = location.getLatitude();
                            double longtitude = location.getLongitude();
                            address = getCompleteAddressString(latitude, longtitude);
//                            Log.d(TAG, "Address: "+address);
                            location_view.setText(address);
                            mLocation = latitude+" "+ longtitude;
//                            Log.d(TAG, "XY: "+mLocation);
                        } else {
                            Log.d(TAG, "location is null");
                        }
                    }
                });

        String type = getIntent().getStringExtra("type");
        if(type.equals("BITMAP")) {
            Bitmap bitmap = getIntent().getExtras().getParcelable("name");
            mImageUri = getImageUri(getApplicationContext(), bitmap);
            Picasso.with(this).load(mImageUri).into(photo);
        } else if (type.equals("URI")) {
            mImageUri = getIntent().getExtras().getParcelable("name");
            Picasso.with(this).load(mImageUri).into(photo);
        }

        share.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mUploadTask != null && mUploadTask.isInProgress()) {
                    Toast.makeText(New_photo.this, "Upload in progress", Toast.LENGTH_SHORT).show();
                } else {
                    uploadFile();
                }
            }
        });
    }

    private Uri getImageUri(Context applicationContext, Bitmap photo) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        photo.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        String path = MediaStore.Images.Media.insertImage(New_photo.this.getContentResolver(), photo, "Title", null);
        return Uri.parse(path);
    }

    private String getCompleteAddressString(double LATITUDE, double LONGITUDE) {
        String strAdd = "";
        Geocoder geocoder = new Geocoder(this, Locale.getDefault());
        try {
            List<Address> addresses = geocoder.getFromLocation(LATITUDE, LONGITUDE, 1);
            if (addresses != null) {
                Address returnedAddress = addresses.get(0);
                StringBuilder strReturnedAddress = new StringBuilder("");

                for (int i = 0; i <= returnedAddress.getMaxAddressLineIndex(); i++) {
                    strReturnedAddress.append(returnedAddress.getAddressLine(i)).append("\n");
                }
                strAdd = strReturnedAddress.toString();
                Log.w("Address", strReturnedAddress.toString());
            } else {
                Log.w("Address", "No Address returned!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.w("Address", "Canont get Address!");
        }
        return strAdd;
    }

    private String getFileExtension(Uri uri) {
        ContentResolver cR = getContentResolver();
        MimeTypeMap mime = MimeTypeMap.getSingleton();
        return mime.getExtensionFromMimeType(cR.getType(uri));
    }

    private void uploadFile() {
        final String uploadId = mDatabaseRef.push().getKey();
        if (mImageUri != null && !description.getText().toString().trim().equals("") && !tag.getText().toString().trim().equals("")) {
            StorageReference fileReference = mStorageRef.child(uploadId
                    + "." + getFileExtension(mImageUri));

            mUploadTask = fileReference.putFile(mImageUri)
                    .addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
                        @Override
                        public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {

                            label(mImageUri, uploadId);
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Toast.makeText(New_photo.this, e.getMessage(), Toast.LENGTH_SHORT).show();
                            Intent i = new Intent(getApplicationContext(), Feedback.class);
                            i.putExtra("uri", mImageUri);
                            i.putExtra("description", description.getText().toString().trim());
                            i.putExtra("tag", tag.getText().toString().trim());
                            i.putExtra("address", address);
                            startActivity(i);
                        }
                    })
                    .addOnProgressListener(new OnProgressListener<UploadTask.TaskSnapshot>() {
                        @Override
                        public void onProgress(UploadTask.TaskSnapshot taskSnapshot) {
                            double progress = (100.0 * taskSnapshot.getBytesTransferred() / taskSnapshot.getTotalByteCount());

                        }
                    });
        } else {
            Toast.makeText(this, "please fill all contents!", Toast.LENGTH_SHORT).show();
        }
    }

    private void label(Uri imageUri, final String uploadId) {
        FirebaseVisionImage image;
        try {
            image = FirebaseVisionImage.fromFilePath(getApplicationContext(), imageUri);
            FirebaseVisionImageLabeler labeler = FirebaseVision.getInstance()
                    .getOnDeviceImageLabeler();
            labeler.processImage(image)
                    .addOnSuccessListener(new OnSuccessListener<List<FirebaseVisionImageLabel>>() {
                        @Override
                        public void onSuccess(List<FirebaseVisionImageLabel> labels) {
                            String mm = "";
                            String isGraffiti = "false";
                            boolean wall = false;
                            boolean poster = false;
                            for (FirebaseVisionImageLabel label: labels) {
                                String text = label.getText();
                                String entityId = label.getEntityId();
                                float confidence = label.getConfidence();
                                if(labels.indexOf(label) != labels.size()-1) {
                                    mm = mm + text + " - " + confidence + ",";
                                } else {
                                    mm = mm + text + " - " + confidence + ".";
                                }
                                if (text.equals("Wall") && confidence > 0.8) {
                                    wall = true;
//                                    Log.w(TAG, "test1");
                                }
                                if (text.equals("Poster") && confidence > 0.4) {
                                    poster = true;
//                                    Log.w(TAG, "test2");
                                }
                            }
                            if (wall && poster) {
                                isGraffiti = "true";
                            }

                            Upload upload = new Upload(uid, description.getText().toString().trim(), tag.getText().toString().trim(), mLocation, mm, isGraffiti);
                            mDatabaseRef.child(uploadId).setValue(upload);

                            Toast.makeText(New_photo.this, "Upload successful", Toast.LENGTH_LONG).show();

                            Intent i = new Intent(getApplicationContext(), Feedback.class);
                            i.putExtra("uri", mImageUri);
                            i.putExtra("description", description.getText().toString().trim());
                            i.putExtra("tag", tag.getText().toString().trim());
                            i.putExtra("address", address);
                            startActivity(i);
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            message = "No matched labels!";
                        }
                    });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
