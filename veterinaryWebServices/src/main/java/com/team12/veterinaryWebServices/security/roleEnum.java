package com.team12.veterinaryWebServices.security;

import org.springframework.security.core.GrantedAuthority;

public enum roleEnum implements GrantedAuthority {

    AD("ADMIN"),
    EMP("EMPLOYEE"),
    MAN("MANAGER"),
    CUS("CUSTOMER");

    roleEnum(String s) {
    }

    @Override
    public String getAuthority(){
        return this.name();
    }
}
