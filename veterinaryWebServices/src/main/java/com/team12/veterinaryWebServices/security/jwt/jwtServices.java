package com.team12.veterinaryWebServices.security.jwt;

import com.team12.veterinaryWebServices.model.profile;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class jwtServices {

    public String generateToken(profile profile) {

        Date now = new Date();
        Date expiryDate = new Date(System.currentTimeMillis() + 1800000);
        String SECRET = "NhunGCAItoI";

        return Jwts.builder()
                .setSubject(profile.getUSERNAME())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS512, SECRET)
                .compact();
    }
}
