package com.team12.veterinaryWebServices;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
public class VeterinaryWebServicesApplication {

	public static void main(String[] args) {
		SpringApplication.run(VeterinaryWebServicesApplication.class, args);
	}

}
