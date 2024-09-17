package com.team12.veterinaryWebServices.security.JWT;

import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.role;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
public class LoginDetail implements UserDetails {

    private Long id;
    private String username;
    private String email;
    private String password;
    private role role;

    public LoginDetail (profile profile){
        this.id = profile.getProfileID();
        this.username = profile.getUSERNAME();
        this.email = profile.getProfileEMAIL();
        this.password = profile.getPASSWORD();
        this.role = profile.getRole();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> list = new ArrayList<GrantedAuthority>();
        list.add(new SimpleGrantedAuthority(role.getRoleNAME()));
        return list;
    }
}
