{
    info_hash = $1
    is_open = $2
    is_active = $3
    is_complete = $4
    completed_chunks = $5
    size_chunks = $6

    up_rate = $7
    down_rate = $8

    peers_connected = $9
    peers_not_connected = $10

    name = $11

    # !!!!!!!!!!!!!!!!!!!!!!
    # Remember to update 'i'
    # !!!!!!!!!!!!!!!!!!!!!!
    for (i = 12; i <= NF; i++)
	name = name " " $(i)

    if (is_active == 1)
        state = "active";
    else if (is_open == 1)
        state = "open";
    else
        state = "closed";

    if (is_complete == 1)
        progress = "complete";
    else
        progress = " partial";

    print info_hash, state, progress, "chunks:" completed_chunks "/" size_chunks, "rate:" up_rate "/" down_rate, "peers:" peers_connected "/" peers_not_connected, name
}
