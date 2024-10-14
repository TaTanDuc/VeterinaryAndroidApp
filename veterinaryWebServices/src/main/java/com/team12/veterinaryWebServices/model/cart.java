package com.team12.veterinaryWebServices.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import lombok.Data;
import org.hibernate.annotations.Formula;

import java.util.List;
import java.util.Objects;

@Data
@Entity
@Table(name = "cart")
public class cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cartID")
    private Long cartID;

    @OneToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @OneToMany(mappedBy = "cart")
    private List<cartDetail> cartDetails;

    @Column(name = "TOTAL", columnDefinition = "INT DEFAULT 0")
    private long TOTAL;

    @Override
    public int hashCode() {
        return Objects.hash(cartID); // Use a unique identifier instead
    }
}
