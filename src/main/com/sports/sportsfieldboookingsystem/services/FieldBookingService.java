package com.sports.sportsfieldboookingsystem.services;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.FieldBooking.BookingStatus;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.repositories.FieldBookingRepository;

@Service
public class FieldBookingService {

    @Autowired
    private FieldBookingRepository fieldBookingRepository;

    @Autowired
    private SportsFieldService sportsFieldService;

    public List<FieldBooking> getAllBookings() {
        return fieldBookingRepository.findAll();
    }

    public Optional<FieldBooking> getBookingById(Long id) {
        return fieldBookingRepository.findById(id);
    }

    public List<FieldBooking> getBookingsByUser(String username) {
        return fieldBookingRepository.findByUsername(username);
    }

    public List<FieldBooking> getBookingsByField(Long fieldId) {
        return fieldBookingRepository.findByFieldId(fieldId);
    }

    public List<FieldBooking> getBookingsByStatus(BookingStatus status) {
        return fieldBookingRepository.findByStatus(status);
    }

    public List<FieldBooking> getUserBookingsByStatus(String username, BookingStatus status) {
        return fieldBookingRepository.findByUsernameAndStatus(username, status);
    }

    public boolean isFieldAvailable(Long fieldId, LocalDateTime startTime, LocalDateTime endTime) {
        List<FieldBooking> overlappingBookings = fieldBookingRepository.findOverlappingBookings(fieldId, startTime, endTime);
        return overlappingBookings.isEmpty();
    }

    public FieldBooking createBooking(String username, Long fieldId, LocalDateTime startTime, LocalDateTime endTime,
            String notes, Integer numberOfPlayers) {

        // Validate input parameters
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }

        if (fieldId == null) {
            throw new IllegalArgumentException("Field ID cannot be null");
        }

        if (startTime == null || endTime == null) {
            throw new IllegalArgumentException("Start time and end time cannot be null");
        }

        if (startTime.isAfter(endTime)) {
            throw new IllegalArgumentException("Start time must be before end time");
        }

        if (startTime.isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Cannot book for past time");
        }

        // Check if field is available
        if (!isFieldAvailable(fieldId, startTime, endTime)) {
            throw new IllegalArgumentException("Field is not available for the selected time period");
        }

        // Calculate total price
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(fieldId);
        if (!optionalField.isPresent()) {
            throw new IllegalArgumentException("Field not found");
        }

        SportsField field = optionalField.get();
        long hours = ChronoUnit.HOURS.between(startTime, endTime);
        if (hours < 1) hours = 1; // Minimum 1 hour

        Float totalPrice = field.getPricePerHour() * hours;

        // Create booking
        FieldBooking booking = new FieldBooking(
            username,
            fieldId,
            startTime,
            endTime,
            totalPrice,
            BookingStatus.PENDING,
            notes,
            numberOfPlayers
        );

        try {
            return fieldBookingRepository.save(booking);
        } catch (Exception e) {
            // Log lỗi để dễ debug
            System.err.println("Error saving booking: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error saving booking: " + e.getMessage(), e);
        }
    }

    public FieldBooking updateBookingStatus(Long bookingId, BookingStatus newStatus) {
        Optional<FieldBooking> optionalBooking = fieldBookingRepository.findById(bookingId);
        if (!optionalBooking.isPresent()) {
            throw new RuntimeException("Booking not found");
        }

        FieldBooking booking = optionalBooking.get();
        booking.setStatus(newStatus);

        return fieldBookingRepository.save(booking);
    }

    public void cancelBooking(Long bookingId) {
        updateBookingStatus(bookingId, BookingStatus.CANCELLED);
    }

    public void confirmBooking(Long bookingId) {
        updateBookingStatus(bookingId, BookingStatus.CONFIRMED);
    }

    public void completeBooking(Long bookingId) {
        updateBookingStatus(bookingId, BookingStatus.COMPLETED);
    }

    /**
     * Lấy danh sách đặt sân theo ngày và sân
     * @param fieldId ID của sân
     * @param date Ngày cần xem lịch
     * @return Danh sách các đặt sân trong ngày
     */
    public List<FieldBooking> getBookingsByFieldAndDate(Long fieldId, LocalDate date) {
        return fieldBookingRepository.findByFieldIdAndDate(fieldId, date);
    }

    /**
     * Lấy danh sách tất cả đặt sân theo ngày
     * @param date Ngày cần xem lịch
     * @return Danh sách các đặt sân trong ngày
     */
    public List<FieldBooking> getBookingsByDate(LocalDate date) {
        return fieldBookingRepository.findByDate(date);
    }

    /**
     * Kiểm tra xem khung giờ có khả dụng không
     * @param fieldId ID của sân
     * @param date Ngày cần kiểm tra
     * @param hour Giờ cần kiểm tra (0-23)
     * @return true nếu khung giờ khả dụng, false nếu đã có người đặt
     */
    public boolean isTimeSlotAvailable(Long fieldId, LocalDate date, int hour) {
        LocalDateTime startTime = date.atTime(hour, 0);
        LocalDateTime endTime = date.atTime(hour + 1, 0);
        return isFieldAvailable(fieldId, startTime, endTime);
    }
}
