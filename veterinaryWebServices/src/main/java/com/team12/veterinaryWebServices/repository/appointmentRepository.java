package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.appointment;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Repository
public interface appointmentRepository extends JpaRepository<appointment, Long> {

    @Query(value = "SELECT * FROM appointment WHERE YEARWEEK('appointment.appointmentdate', 1) = YEARWEEK(CURDATE(), 1) ",nativeQuery = true)
    List<appointment> getThisWeekAppointment ();

    @Query(value = "SELECT * FROM appointment WHERE YEARWEEK('appointment.appointmentdate', 1) = YEARWEEK(CURDATE(), 1) AND appointment.profileid = ?1",nativeQuery = true)
    List<appointment> getUserAppointment (Long userID);

    @Query(value = "SELECT * FROM appointment a WHERE a.appointmentdate = ?1 AND HOUR(a.appointmenttime) = ?2", nativeQuery = true)
    List<appointment> getAppointmentByDateAndTime(Date date, Time time);
}
