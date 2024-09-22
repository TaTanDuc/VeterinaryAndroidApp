package com.team12.veterinaryWebServices.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ERRORCODE {

    USER_EXISTED(601, "User already existed!", HttpStatus.BAD_REQUEST),
    USER_DOES_NOT_EXIST(602, "User doesn't exist!", HttpStatus.BAD_REQUEST),
    PASSWORD_NOT_MATCH(603, "User password isn't right!", HttpStatus.CONFLICT),
    UNAUTHENTICATED(610, "Unauthenticated!",HttpStatus.UNAUTHORIZED),

    PET_DOES_NOT_EXIST(701, "Pet doesn't exist!", HttpStatus.BAD_REQUEST),
    NOT_PET_OWNER(702, "You are not the owner of this pet!", HttpStatus.UNAUTHORIZED)
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
