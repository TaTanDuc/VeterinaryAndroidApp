package com.team12.veterinaryWebServices.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ERRORCODE {

    USER_EXISTED(601, "User already existed!", HttpStatus.BAD_REQUEST),
    USER_DOES_NOT_EXIST(602, "User doesn't exist!", HttpStatus.BAD_REQUEST),
    PASSWORD_NOT_MATCH(603, "User password isn't right!", HttpStatus.CONFLICT),
    PASS_WORD_CANT_NULL(604, "Password can't be left blank!", HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(610, "Unauthenticated!",HttpStatus.UNAUTHORIZED),

    PET_DOES_NOT_EXIST(701, "Pet doesn't exist!", HttpStatus.BAD_REQUEST),
    NOT_PET_OWNER(702, "You are not the owner of this pet!", HttpStatus.UNAUTHORIZED),

    SERVICE_DOES_NOT_EXIST(801, "Service doesn't exist!", HttpStatus.NO_CONTENT),
    NO_COMMENT(805, "There is no comment here!", HttpStatus.NO_CONTENT),

    CART_DOES_NOT_EXIST(901, "Cart doesn't exist!", HttpStatus.BAD_REQUEST),
    NOT_CART_OWNER(902, "This is not your cart!", HttpStatus.CONFLICT),
    ITEM_OVER_STOCK(903, "Your item quantity is over the stock limit!", HttpStatus.BAD_REQUEST)
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
