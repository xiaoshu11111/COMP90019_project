package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.io.IOException;

public class Home_page extends AppCompatActivity {

    ImageView add_photo, photo_library;
    private static final int PICK_IMAGE_REQUEST = 102;
    private static final int REQUEST_IMAGE_CAPTURE = 101;
    private Uri mImageUri;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home_page);

        add_photo = findViewById(R.id.add_photo);
        photo_library = findViewById(R.id.photo_library);
        BottomNavigationView bottomNavigationView = findViewById(R.id.navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                switch (item.getItemId()) {
                    case R.id.settings:
                        Intent intent = new Intent(getApplicationContext(), Setting.class);
                        startActivity(intent);
                        break;
                    case R.id.photo:
                        if(add_photo.getVisibility() == View.VISIBLE) {
                            add_photo.setVisibility(View.INVISIBLE);
                        } else {
                            add_photo.setVisibility(View.VISIBLE);
                        }
                        if(photo_library.getVisibility() == View.VISIBLE) {
                            photo_library.setVisibility(View.INVISIBLE);
                        } else {
                            photo_library.setVisibility(View.VISIBLE);
                        }

                        break;
                    case R.id.profile:
                        Intent intent1 = new Intent(getApplicationContext(), Profile.class);
                        startActivity(intent1);
                        break;
                }
                return true;
            }
        });

        add_photo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                takePicture();
            }
        });

        photo_library.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openFileChooser();
            }
        });
    }

    private void openFileChooser() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(intent, PICK_IMAGE_REQUEST);
    }

    public void takePicture()
    {
        Intent imageTakeIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(imageTakeIntent, REQUEST_IMAGE_CAPTURE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == PICK_IMAGE_REQUEST && resultCode == RESULT_OK
                && data != null && data.getData() != null) {
            mImageUri = data.getData();

            Intent i = new Intent(this, New_photo.class);
            i.putExtra("type", "URI");
            i.putExtra("name", mImageUri);
            startActivity(i);

        } else if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK) {
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            Intent i = new Intent(this, New_photo.class);
            i.putExtra("name", photo);
            i.putExtra("type", "BITMAP");
            startActivity(i);
        }

    }
}
