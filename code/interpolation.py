class GPSMeasurement:
    def __init__(self, timestamp, latitude, longitude):
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude

    def get_interpolation(self, other_gps, ts):
        lan = (self.latitude + (other_gps.latitude - self.latitude) * (ts - self.timestamp) / (other_gps.timestamp - self.timestamp))
        lon = (self.longitude + (other_gps.longitude - self.longitude) * (ts - self.timestamp) / (other_gps.timestamp - self.timestamp))
        return GPSMeasurement(ts, lan, lon)
