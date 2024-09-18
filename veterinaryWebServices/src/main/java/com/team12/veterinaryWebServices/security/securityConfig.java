package com.team12.veterinaryWebServices.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity
public class securityConfig {

    public SecurityFilterChain filterChain (HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(authorize -> authorize
                .requestMatchers("/api/user/login/**","/api/user/register").permitAll()
                .requestMatchers("/api/admin/**").hasRole("AD")
                .anyRequest().authenticated()
        );
        return http.build();
    }
}
