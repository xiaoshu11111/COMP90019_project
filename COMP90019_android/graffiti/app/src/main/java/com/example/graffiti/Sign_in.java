/*
  Sign_in.java
  Graffiti
  Sign in page : allow user to log in.
  Created by Xiaoshu Chen on 2019/10/18.
  Copyright © 2019 Xiaoshu All rights reserved.
*/
package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class Sign_in extends AppCompatActivity {

    private static final String TAG = "Sign_in";

    private FirebaseAuth mAuth;
    EditText pas,ema;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sign_in);

        mAuth = FirebaseAuth.getInstance();

        ema = (EditText) findViewById( R.id.email);
        pas = (EditText) findViewById(R.id.password);

    }

    public void loginBtn(View view) {
        String email = ema.getText().toString();
        String pass = pas.getText().toString();

        // using the email and password user  entered to log in
        mAuth.signInWithEmailAndPassword(email, pass)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            Log.d(TAG, "Log in success!");
                            FirebaseUser user = mAuth.getCurrentUser();
                            Toast.makeText(Sign_in.this, "Log in success!",
                                    Toast.LENGTH_SHORT).show();

                            Intent intent = new Intent(getApplicationContext(), Home_page.class);
                            startActivity(intent);
                        } else {
                            // If sign in fails, display a message to the user.
                            Log.w(TAG, "signInWithEmail:failure", task.getException());
                            Toast.makeText(Sign_in.this, "Authentication failed.",
                                    Toast.LENGTH_SHORT).show();
                        }
                     }
        });
    }
}


