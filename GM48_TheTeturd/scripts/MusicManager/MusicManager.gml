function MusicManager() constructor{
	
	self.menu_music = noone;
	self.menu_fade = 1;
	self.menu_fade_spd = .2;
	
	self.noises = [snd_atmo1,snd_atmo2,snd_atmo3,snd_atmo4,snd_atmo5,snd_atmo6]
	self.min_noise_time = 45;
	self.max_noise_time = 130;
	self.noise_time = random_range(20,30);
	
	static StepMusic = function(){
		if(global.title_screen && !Camera.starting_game){
			if(self.menu_music==noone){
				self.menu_music = audio_play_sound(snd_menu_music, 1,true);
			}
		}else{
			if(self.menu_music!=noone){
				self.menu_fade-=self.menu_fade_spd*delta_time/1_000_000;
				audio_sound_gain(self.menu_music, menu_fade, 0)
				if(self.menu_fade<=0){
					audio_stop_sound(self.menu_music);
					self.menu_music = noone;
					self.menu_fade = 1;
				}
			}
			
			self.noise_time-=delta_time/1_000_000;
			if(self.noise_time<0){
				audio_play_sound(self.noises[floor(random(array_length(self.noises)))], 1,false);
				self.noise_time = random_range(self.min_noise_time,self.max_noise_time);	
			}
		}
	}
}