init() {
    setDvar("scr_allowFileIo", "1");
    level thread onPlayerConnected();
    level thread onPlayerDisconnect();
    level.onplayerkilled = ::onPlayerKilled;
}

onPlayerConnected() {
    for(;;) {
        level waittill( "connected", player );
        thread call_event("player_connected", player.name);

        player thread onPlayerSpawned();
        player thread onPlayerDeath();
    }
}

onPlayerSpawned() {
    for(;;) {
        self waittill( "spawned_player" );
        thread call_event("player_spawned", self.name);
    }
}

onPlayerDeath() {
    for(;;) {
        self waittill( "death" );
        thread call_event("player_death", self.name);
    }
}

onPlayerKilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration) {
    thread call_event("player_killed", self.name, attacker.name, smeansofdeath);
}

onPlayerDisconnect() {
    for(;;) {
        level waittill( "disconnect", player );
        thread call_event("player_disconnect", player.name);
    }
}

call_event( event, arg1, arg2, arg3 ) {
    if (arg1 == undefined || arg1 == "" ) {
        event_log = "{ \"event\": \"" + event + "\" }";
    } else if (arg2 == undefined || arg2 == "" && arg3 == undefined || arg3 == "" ) {
        event_log = "{ \"event\": \"" + event + "\", \"args\": [\"" + arg1 + "\"] }";
    } else {
        event_log = "{ \"event\": \"" + event + "\", \"args\": [\"" + arg1 + "\", \"" + arg2 + "\", \"" + arg3 + "\"] }";
    }
    
    file = fs_fopen("event_" + event + ".jsonl", "append");
    fs_write(file, event_log + "\n");
    fs_fclose(file);

    println("^2[event]: " + event_log);
}