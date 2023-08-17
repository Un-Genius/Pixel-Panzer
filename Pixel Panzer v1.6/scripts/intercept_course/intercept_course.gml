/// intercept_course(_origin,_target,_speed)
//
//  Returns the course direction required to hit a moving _target
//  at a given projectile _speed, or (-1) if no solution is found.
//
//      _origin      instance with position (x,y), real
//      _target      instance with position (x,y) and (_speed), real
//      _speed       _speed of the projectile, real
//
/// GMLscripts.com/license
function intercept_course(_origin,_target,pspeed)
{
    var dir,alpha,phi,beta;
    dir = point_direction(_origin.x,_origin.y,_target.x,_target.y);
    alpha = _target.speed / pspeed;
    phi = degtorad(_target.direction - dir);
    beta = alpha * sin(phi);
    if (abs(beta) >= 1) {
        return (-1);
    }
    dir += radtodeg(arcsin(beta));
    return dir;
}