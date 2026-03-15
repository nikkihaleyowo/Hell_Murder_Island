function RaidManager() constructor {
    self.round = 1;
    self.in_round = false;
    self.prep_time = 120;
    self.round_time = 60;
    self.timer = self.prep_time;
    
    self.min_enemies = 5;
    self.max_enemies = 7;
    self.max_enities = 20; 
    
    self.min_spawn_time = 15;
    self.max_spawn_time = 25;
    
    self.growth_rate = 1.25; // 15% more enemies per round
    self.stat_growth_hp = 5; // +20 HP per round
    self.stat_growth_atk = 2; // +2 ATK per round
    self.base_health = 25;
	self.base_attack = 10;
	
    self.round_just_started = true;
    self.spawn_dist = 2000;
    self.spawn_time = 0;
    self.enimies_round = 0;
	
	self.start_timer = 60;

    static SpawnHostile = function(_num) {
        for(var i = 0; i < _num; i++) {
            var _r = random(360);
            var _x = Camera.player.x + dcos(_r) * self.spawn_dist;
            var _y = Camera.player.y - dsin(_r) * self.spawn_dist;
            
            var _inst = noone;
			
			if(random(1)<.1){
				 _inst = instance_create_depth(_x, _y, 0, obj_crawler);
			}else{
				 _inst = instance_create_depth(_x, _y, 0, obj_hostile);	
			}
            

            _inst.hp = self.base_health + (self.round * self.stat_growth_hp);
            _inst.max_hp = _inst.hp;
            _inst.attack_damage = self.base_attack + (self.round * self.stat_growth_atk);
			if(!self.in_round){
				_inst.attacked = true;
				_inst.hp = (self.base_health + (self.round * self.stat_growth_hp))/2;	
			}
		}
    }

    static StepWorld = function() {
	    if(!self.in_round) {
	        self.timer -= delta_time / 1_000_000;
			
			if(self.start_timer<=0){
		        if(self.timer > 10) { 
		            if(irandom(4000) == 0 && instance_number(obj_hostile) < 2) {
		                SpawnHostile(irandom_range(1, 2));
		            }
		        }
			}else{
				self.start_timer -= delta_time / 1_000_000;
			}

	        if(self.timer <= 0) {
	            self.in_round = true;
	            self.timer = self.round_time;
	            global.hell_mode = true;
	            self.enimies_round = floor(random_range(self.min_enemies, self.max_enemies));
	        }
	    } else {
	        if(self.round_just_started) {
	            self.round_just_started = false;
	            var _num = floor(self.enimies_round / 4);
	            self.enimies_round -= _num;
	            SpawnHostile(_num);
	            self.spawn_time = random_range(self.min_spawn_time, self.max_spawn_time);
	        }
        
	        self.spawn_time -= delta_time / 1_000_000;
	        if(self.spawn_time <= 0) {
	            self.spawn_time = random_range(self.min_spawn_time, self.max_spawn_time);
	            if(instance_number(obj_hostile) < self.max_enities) {
	                var _r = clamp(floor(self.enimies_round / 4), 1, self.enimies_round);
	                self.enimies_round -= _r;
	                SpawnHostile(_r);
	            }
	        }
        
	        self.timer -= delta_time / 1_000_000;
	        if(self.timer <= 0 || (self.enimies_round <= 0 && instance_number(obj_hostile) == 0)) {
	            self.AdvanceRound();
	        }
	    }
	}

    static AdvanceRound = function() {
        self.round++;
        self.in_round = false;
        self.round_just_started = true;
        self.timer = self.prep_time;
        global.hell_mode = false;
        
        self.min_enemies = floor(self.min_enemies * self.growth_rate);
        self.max_enemies = floor(self.max_enemies * self.growth_rate);
        self.max_enities = min(150, self.max_enities + 5); 
        
        self.min_spawn_time = max(2, self.min_spawn_time * 0.98);
        self.max_spawn_time = max(4, self.max_spawn_time * 0.98);
    }
	
	static Draw = function(){
		if(self.in_round){
			draw_set_halign(fa_center)
			draw_set_color(c_white)	
			draw_text(display_get_gui_width()/2,50,"Round: "+string(self.round))
			draw_text(display_get_gui_width()/2,70,string(self.timer)+"s")
			
			draw_set_halign(fa_left)
		}else{
			draw_set_halign(fa_center)
			draw_set_color(c_white)	
			draw_text(display_get_gui_width()/2,50,"Next Round In")
			draw_text(display_get_gui_width()/2,70,string(self.timer)+"s")
			
			draw_set_halign(fa_left)
		}
		
		draw_set_halign(fa_right);
		draw_set_font(fnt_round);
		draw_set_color(c_white);
		draw_text(display_get_gui_width()-70,20,string(self.round))
		draw_set_halign(fa_left);
		draw_set_font(fnt_game);
	}
}