/*
  Setting.java
  Graffiti
  Setting page : allow user to view te settings.
  Created by Xiaoshu Chen on 2019/10/18.
  Copyright © 2019 Xiaoshu All rights reserved.
*/
package com.example.graffiti;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

public class Setting extends AppCompatActivity {

    ImageView back;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);

        back = findViewById(R.id.back);

        back.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                finish();
            }
        });
    }
}
