def create_parking_space_map(segments):
    parking_cars_segments = [s for s in segments if is_parking_car(s.get_ground_truth())]
    clustering_data = [[s.first_measure().latitude, s.first_measure().longitude,
                        s.last_measure().latitude, s.last_measure().longitude] for s in parking_cars_segments]

    db = DBSCAN(metric=mc_metric, eps=8.0, min_samples=2).fit(clustering_data)

    clusters = []
    noise_cluster = None

    # loop over all detected clusters
    for k in set(db.labels_):
        class_member_mask = (db.labels_ == k)  # True if item belongs to cluster k

        lat = [x[0] for i, x in enumerate(clustering_data) if class_member_mask[i]]
        long = [x[1] for i, x in enumerate(clustering_data) if class_member_mask[i]]
        lat.extend([x[2] for i, x in enumerate(clustering_data) if class_member_mask[i]])
        long.extend([x[3] for i, x in enumerate(clustering_data) if class_member_mask[i]])

        if k == -1:
            noise_cluster = get_noise_cluster(lat, long)
        else:
            clusters.append(get_parking_zone_clusters(lat, long))

    return clusters, noise_cluster
