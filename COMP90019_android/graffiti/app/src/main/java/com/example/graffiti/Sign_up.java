package com.example.graffiti;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;

public class Sign_up extends AppCompatActivity {

    EditText email_text, name_text, password_text, confirm_text;
    private FirebaseAuth mAuth;
    private static final String TAG = "SignUp";
    private String email, name, password, confirm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        email_text = findViewById(R.id.email);
        name_text = findViewById(R.id.name);
        password_text = findViewById(R.id.password);
        confirm_text = findViewById(R.id.confirm);

        mAuth = FirebaseAuth.getInstance();
    }

    public void signupBtn(View view) {
        email = email_text.getText().toString();
        name = name_text.getText().toString();
        password = password_text.getText().toString();
        confirm = confirm_text.getText().toString();

        if(password.length()>=6) {
            if (password.equals(confirm)) {
                mAuth.createUserWithEmailAndPassword(email, password)
                        .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                            @Override
                            public void onComplete(@NonNull Task<AuthResult> task) {
                                if (task.isSuccessful()) {
                                    Log.d(TAG, "createUserWithEmail:success");

                                    updateProfile();

                                } else {
                                    Log.w(TAG, "createUserWithEmail:failure", task.getException());
                                    Toast.makeText(Sign_up.this, "Authentication failed.",
                                            Toast.LENGTH_SHORT).show();
                                }

                            }
                        });
            } else {
                Toast.makeText(Sign_up.this, "Password doesn't match!",
                        Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(Sign_up.this, "Password should be at least 6 characters!",
                    Toast.LENGTH_SHORT).show();
        }
    }

    public void updateProfile(){
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        UserProfileChangeRequest profileUpdates = new UserProfileChangeRequest.Builder()
                .setDisplayName(name)
                .build();

        user.updateProfile(profileUpdates)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        if (task.isSuccessful()) {
                            Toast.makeText(Sign_up.this, "Sign up success!",
                                    Toast.LENGTH_SHORT).show();

                            Intent intent = new Intent(getApplicationContext(), Home_page.class);
                            startActivity(intent);
                        }
                    }
                });
    }
}
