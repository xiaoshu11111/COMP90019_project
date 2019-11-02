/*
  Feedback.java
  Graffiti
  Feedback page : view the uploaded photo details after uploading
  Created by Xiaoshu Chen on 2019/10/18.
  Copyright © 2019 Xiaoshu All rights reserved.
*/

package com.example.graffiti;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

public class Feedback extends AppCompatActivity {

    ImageView photo, home;
    TextView description, tag, location;
    private Uri uri;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

        photo = findViewById(R.id.photo);
        description = findViewById(R.id.description);
        tag = findViewById(R.id.tag);
        location = findViewById(R.id.location);
        home =findViewById(R.id.home);

        home.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                Intent intent = new Intent(getApplicationContext(), Home_page.class);
                startActivity(intent);
            }
        });

        //read all information from the last activity
        uri = getIntent().getExtras().getParcelable("uri");
        String description_str = getIntent().getStringExtra("description");
        String tag_str = getIntent().getStringExtra("tag");
        String address_str = getIntent().getStringExtra("address");

        //load image to the image view
        Picasso.with(this).load(uri).into(photo);
        description.setText(description_str);
        tag.setText(tag_str);
        location.setText(address_str);
    }
}
