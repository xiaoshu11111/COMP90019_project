/*
  Change_name.java
  Graffiti
  Change Name page : allow user to change their displayname.
  Created by Xiaoshu Chen on 2019/10/18.
  Copyright © 2019 Xiaoshu All rights reserved.
*/

package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;

public class Change_name extends AppCompatActivity {

    EditText change_name;
    Button confirm;
    ImageView back;
    String name_context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_name);

        change_name = findViewById(R.id.change_name);
        confirm = findViewById(R.id.confirm);
        back = findViewById(R.id.back);

        back.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                finish();
            }
        });
    }

    public void confirmBtn(View view) {
        name_context = change_name.getText().toString();

        //get the current user details before chaneg name
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        //use firebase build-in update profile function to change name
        UserProfileChangeRequest profileUpdates = new UserProfileChangeRequest.Builder()
                .setDisplayName(name_context)
                .build();

        user.updateProfile(profileUpdates)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        if (task.isSuccessful()) {
                            Toast.makeText(Change_name.this, "Update success!",
                                    Toast.LENGTH_SHORT).show();
                            Intent intent = new Intent(getApplicationContext(), Profile.class);
                            startActivity(intent);
                        }
                    }
                });
    }
}
