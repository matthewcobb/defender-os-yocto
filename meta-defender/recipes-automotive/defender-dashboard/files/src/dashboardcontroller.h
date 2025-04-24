#ifndef DASHBOARDCONTROLLER_H
#define DASHBOARDCONTROLLER_H

#include <QObject>
#include <QString>
#include <QTimer>

class DashboardController : public QObject
{
    Q_OBJECT

    // Vehicle data properties
    Q_PROPERTY(int speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(int rpm READ rpm NOTIFY rpmChanged)
    Q_PROPERTY(int fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(double temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(bool engineWarning READ engineWarning NOTIFY engineWarningChanged)
    Q_PROPERTY(QString currentGear READ currentGear NOTIFY currentGearChanged)
    Q_PROPERTY(bool headlightsOn READ headlightsOn NOTIFY headlightsOnChanged)
    Q_PROPERTY(bool turnSignalLeft READ turnSignalLeft NOTIFY turnSignalLeftChanged)
    Q_PROPERTY(bool turnSignalRight READ turnSignalRight NOTIFY turnSignalRightChanged)

public:
    explicit DashboardController(QObject *parent = nullptr);

    // Getters
    int speed() const { return m_speed; }
    int rpm() const { return m_rpm; }
    int fuelLevel() const { return m_fuelLevel; }
    double temperature() const { return m_temperature; }
    bool engineWarning() const { return m_engineWarning; }
    QString currentGear() const { return m_currentGear; }
    bool headlightsOn() const { return m_headlightsOn; }
    bool turnSignalLeft() const { return m_turnSignalLeft; }
    bool turnSignalRight() const { return m_turnSignalRight; }

public slots:
    void toggleHeadlights();
    void toggleLeftSignal();
    void toggleRightSignal();
    void setGear(const QString &gear);

signals:
    void speedChanged();
    void rpmChanged();
    void fuelLevelChanged();
    void temperatureChanged();
    void engineWarningChanged();
    void currentGearChanged();
    void headlightsOnChanged();
    void turnSignalLeftChanged();
    void turnSignalRightChanged();

private slots:
    void updateVehicleData();

private:
    // Vehicle data
    int m_speed;
    int m_rpm;
    int m_fuelLevel;
    double m_temperature;
    bool m_engineWarning;
    QString m_currentGear;
    bool m_headlightsOn;
    bool m_turnSignalLeft;
    bool m_turnSignalRight;

    // For demo simulation
    QTimer *m_updateTimer;
};

#endif // DASHBOARDCONTROLLER_H