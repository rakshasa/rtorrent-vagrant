{
    info_hash = $1
    name = $5
    completed_chunks = $6
    size_chunks = $7

    if ( $3 == 1 )    
        state = "active";
    else if ( $2 == 1 )
        state = "open  ";
    else
        state = "closed";

    if ( $4 == 1 )    
        progress = "complete";
    else
        progress = "partial ";

    print info_hash, state, progress, "chunks:" completed_chunks "/" size_chunks, name;
}
