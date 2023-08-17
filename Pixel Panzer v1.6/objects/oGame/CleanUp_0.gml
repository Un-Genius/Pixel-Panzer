/// Clean Up Cameras
camera_destroy(view_camera[0]);

part_type_destroy(global.EngineSmoke);
part_type_destroy(global.shootSpark);
part_type_destroy(global.BulletTrail);
part_type_destroy(global.ExplosionSmoke);
part_type_destroy(global.GranadeSmoke);
part_type_destroy(global.DeadTankSmoke);
part_type_destroy(global.Dirt);
part_type_destroy(global.DamagedSmoke);

//part_emitter_destroy(global.P_System, global.Emitter1);
//part_emitter_destroy(global.P_System, global.Emitter2);
part_system_destroy(global.P_System);
part_system_destroy(global.Clouds_System);