# returns the similarity of two parking car segments s1 and s2
def cluster_metric(s1, s2):
    direction_s1 = (s1.lat1 - s1.lat2, s1.long1 - s1.long2)
    direction_s2 = (s2.lat1 - s2.lat2, s2.long1 - s2.long2)

    angle_in_rad = angle_between(direction_s1, direction_s2)
    if angle_in_rad > math.pi:
        angle_in_rad = 2 * math.pi - angle_in_rad

    # if sensing vehicles are not driving in the same direction, then return max distance
    if angle_in_rad > math.pi / 4:
        return 1000

    dist1 = vincenty((s1.lat1, s1.long1), (s2.lat1, s2.long1)).meters
    dist2 = vincenty((s1.lat2, s1.long2), (s2.lat1, s2.long1)).meters
    dist3 = vincenty((s1.lat1, s1.long1), (s2.lat2, s2.long2)).meters
    dist4 = vincenty((s1.lat2, s1.long2), (s2.lat2, s2.long2)).meters

    # else return the minimum distance between both parking cars
    return min([dist1, dist2, dist3, dist4])

def angle_between(v1, v2):
    v1_u = unit_vector(v1)
    v2_u = unit_vector(v2)
    return np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))

def unit_vector(vector):
    return vector / np.linalg.norm(vector)