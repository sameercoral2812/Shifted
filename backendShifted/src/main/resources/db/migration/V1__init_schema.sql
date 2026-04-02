CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(120) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE drivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    vehicle_type VARCHAR(30) NOT NULL,
    vehicle_number VARCHAR(25) NOT NULL UNIQUE,
    is_online BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(30) NOT NULL,
    current_latitude NUMERIC(10,7),
    current_longitude NUMERIC(10,7),
    rating NUMERIC(3,2),
    total_earnings NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    driver_id UUID REFERENCES drivers(id),
    vehicle_type VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    pickup_address VARCHAR(255) NOT NULL,
    drop_address VARCHAR(255) NOT NULL,
    pickup_latitude NUMERIC(10,7) NOT NULL,
    pickup_longitude NUMERIC(10,7) NOT NULL,
    drop_latitude NUMERIC(10,7) NOT NULL,
    drop_longitude NUMERIC(10,7) NOT NULL,
    estimated_price NUMERIC(12,2) NOT NULL,
    final_price NUMERIC(12,2),
    cancel_reason VARCHAR(255),
    assigned_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id),
    amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    provider VARCHAR(50),
    transaction_reference VARCHAR(120),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE INDEX idx_drivers_status_online ON drivers(status, is_online);
CREATE INDEX idx_drivers_vehicle_type ON drivers(vehicle_type);

CREATE INDEX idx_bookings_user_created ON bookings(user_id, created_at DESC);
CREATE INDEX idx_bookings_driver_status ON bookings(driver_id, status);
CREATE INDEX idx_bookings_status_created ON bookings(status, created_at DESC);

CREATE INDEX idx_payments_booking ON payments(booking_id);
CREATE INDEX idx_payments_status_created ON payments(status, created_at DESC);
