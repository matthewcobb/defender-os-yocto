#include "dashboardcontroller.h"
#include <QRandomGenerator>

DashboardController::DashboardController(QObject *parent)
    : QObject(parent)
    , m_speed(0)
    , m_rpm(0)
    , m_fuelLevel(100)
    , m_temperature(90.0)
    , m_engineWarning(false)
    , m_currentGear("P")
    , m_headlightsOn(false)
    , m_turnSignalLeft(false)
    , m_turnSignalRight(false)
{
    // Set up timer for demo simulation
    m_updateTimer = new QTimer(this);
    connect(m_updateTimer, &QTimer::timeout, this, &DashboardController::updateVehicleData);
    m_updateTimer->start(1000); // Update every second
}

void DashboardController::updateVehicleData()
{
    // This is just a demo simulation
    if (m_currentGear == "D") {
        // If in Drive, simulate driving
        m_speed = qBound(0, m_speed + QRandomGenerator::global()->bounded(-5, 8), 120);
        m_rpm = 800 + (m_speed * 30);
    } else if (m_currentGear == "R") {
        // If in Reverse, simulate backing up
        m_speed = qBound(0, m_speed + QRandomGenerator::global()->bounded(-2, 3), 25);
        m_rpm = 800 + (m_speed * 30);
    } else {
        // Otherwise, car is parked or neutral
        m_speed = 0;
        m_rpm = 800;
    }

    // Random fluctuation of fuel level (slightly decreasing)
    if (QRandomGenerator::global()->bounded(10) == 0) {
        m_fuelLevel = qMax(0, m_fuelLevel - 1);
        emit fuelLevelChanged();
    }

    // Random fluctuation of temperature
    m_temperature = qBound(80.0, m_temperature + QRandomGenerator::global()->bounded(-1.0, 1.0), 110.0);

    // Randomly set engine warning if temperature too high
    if (m_temperature > 105.0 && !m_engineWarning) {
        m_engineWarning = true;
        emit engineWarningChanged();
    } else if (m_temperature < 100.0 && m_engineWarning) {
        m_engineWarning = false;
        emit engineWarningChanged();
    }

    // Turn off signals randomly if they are on
    if (m_turnSignalLeft && QRandomGenerator::global()->bounded(3) == 0) {
        m_turnSignalLeft = false;
        emit turnSignalLeftChanged();
    }

    if (m_turnSignalRight && QRandomGenerator::global()->bounded(3) == 0) {
        m_turnSignalRight = false;
        emit turnSignalRightChanged();
    }

    emit speedChanged();
    emit rpmChanged();
    emit temperatureChanged();
}

void DashboardController::toggleHeadlights()
{
    m_headlightsOn = !m_headlightsOn;
    emit headlightsOnChanged();
}

void DashboardController::toggleLeftSignal()
{
    // Turn off right signal if turning on left
    if (!m_turnSignalLeft && m_turnSignalRight) {
        m_turnSignalRight = false;
        emit turnSignalRightChanged();
    }

    m_turnSignalLeft = !m_turnSignalLeft;
    emit turnSignalLeftChanged();
}

void DashboardController::toggleRightSignal()
{
    // Turn off left signal if turning on right
    if (!m_turnSignalRight && m_turnSignalLeft) {
        m_turnSignalLeft = false;
        emit turnSignalLeftChanged();
    }

    m_turnSignalRight = !m_turnSignalRight;
    emit turnSignalRightChanged();
}

void DashboardController::setGear(const QString &gear)
{
    if (m_currentGear != gear) {
        m_currentGear = gear;
        emit currentGearChanged();
    }
}