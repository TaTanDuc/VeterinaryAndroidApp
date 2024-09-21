package com.team12.veterinaryWebServices.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class authenticationResponse {
    String token;
    boolean authenticated;
}
