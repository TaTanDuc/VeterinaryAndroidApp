package com.team12.veterinaryWebServices.enums;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ERRORCODE {

    USER_EXISTED(601, "User already existed!", HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(602, "Unauthenticated!",HttpStatus.UNAUTHORIZED),
    ;


    ERRORCODE(int code, String message, HttpStatusCode statusCode){
        this.code = code;
        this.message = message;
        this.statusCode = statusCode;
    }

    private final int code;
    private final String message;
    private final HttpStatusCode statusCode;
}
