package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class Profile extends AppCompatActivity {

    ImageView back;
    TextView name_view, email_view, change_password, change_name, sign_out;
    private FirebaseAuth AuthUI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        back = findViewById(R.id.back);
        name_view = findViewById(R.id.name);
        email_view = findViewById(R.id.email);
        change_name = findViewById(R.id.change_name);
        change_password = findViewById(R.id.change_password);
        sign_out = findViewById(R.id.sign_out);

        AuthUI = FirebaseAuth.getInstance();

        change_name.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                Intent intent = new Intent(getApplicationContext(), Change_name.class);
                startActivity(intent);
            }
        });

        change_password.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                Intent intent = new Intent(getApplicationContext(), Change_password.class);
                startActivity(intent);
            }
        });

        sign_out.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                FirebaseAuth.getInstance().signOut();
                Toast.makeText(Profile.this, "Sign out!",
                        Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(getApplicationContext(), Log_in.class);
                startActivity(intent);
            }
        });

        back.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                finish();
            }
        });

        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
        if (user != null) {
            // Name, email address, and profile photo Url
            String name = user.getDisplayName();
            String email = user.getEmail();
            Uri photoUrl = user.getPhotoUrl();

            // Check if user's email is verified
            boolean emailVerified = user.isEmailVerified();

            // The user's ID, unique to the Firebase project. Do NOT use this value to
            // authenticate with your backend server, if you have one. Use
            // FirebaseUser.getIdToken() instead.
            String uid = user.getUid();

            name_view.setText("Name: "+name);
            email_view.setText("Email: "+email);
        }

    }
}
