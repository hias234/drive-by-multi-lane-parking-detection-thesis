def segment_sensor_data(sensor_data, options):
    threshold = options.get('separation_threshold')
    min_speed = options.get('min_speed')

    segments = []
    cur_segment = Segment()
    last_distance = None
    last_timestamp = None
    for measure in sensor_data:
        if should_start_new_segment(cur_segment, measure, last_distance, last_timestamp, threshold):
            # filter standing situations
            if cur_segment.get_avg_speed() >= min_speed:
                segments.append(cur_segment)

            cur_segment = Segment()

        cur_segment.add_raw_sensor_value(measure)

        last_distance = measure.distance
        last_timestamp = measure.timestamp

    segments.append(cur_segment)
    return segments

# a new segment should start if two distances are greather than the threshold or more than one second apart
def should_start_new_segment(cur_segment, measure, last_distance, last_timestamp, threshold):
    return (cur_segment.is_empty() or
            (abs(last_distance - measure.distance) < threshold and
             abs(last_timestamp - measure.timestamp) < 1.0))
