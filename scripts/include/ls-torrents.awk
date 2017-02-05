{
    info_hash = $1
    is_open = $2
    is_active = $3
    is_complete = $4
    completed_chunks = $5
    size_chunks = $6

    up_rate = $7
    down_rate = $8

    name = $9

    # Remember to update 'i'.
    for (i = 10; i <= NF; i++)
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

    print info_hash, state, progress, "chunks:" completed_chunks "/" size_chunks, "rate:" up_rate "/" down_rate, name
}
