%%My MATLAB Implementation of John Cage - Music of Changes

%generic formula for generating a tone
makeNote = @(freq,dur,dyn,oct) dyn*sin(2*pi*(1:dur)/8192 * ((261.625565*oct)*(2.^((freq-1)/12))));

num = 30;               %number of attempts at note generation
dur = 4096;             %0.5 sec
note = [];
freqs = zeros(1,12);    %stores frequencies
idx = 1;                %iterate through above array
valid = 0;              %flag for valid new frequency

for x = 1:num
    sound_or_silence = round(rand); %50 percent probability of note generation    
    
    if(sound_or_silence == 1)      
        len = 2^(round(2*rand));  
        dur = dur*len;             %generates duration
        
        %ensures there are no duplicate frequencies
        while(valid == 0)
            freq = round((11*rand)+1); %frequency in [1,12] range
            freqs(1,idx) = freq;  

            if idx ~= 1
                for y = 1:(idx-1) 
                    if freqs(1,idx) == freqs(1,y)   %if our frequency already exists
                           break;
                    end    
                end
                
                %if traversed through for loop and all of them are different
                if (y == idx-1) && (freqs(1,idx) ~= freqs(1,y))  
                    valid = 1;     %we got a new frequency
                end
               
            else
                valid = 1;  %if idx = 1, exit the loop
            
            end
        end
        
        idx = idx+1;                                    %iterate index
        valid = 0;                                      %reset validity flag
        dyn = round((3*rand)+1);                        %dynamics in [1,4] range
        oct = 2^(round((2*rand)-1));                    %octave location
        note = [note; (makeNote(freq,dur,dyn,oct))'];   %generate the note
        
    else
        note = [note; (zeros(1,dur*2))'];               %no sound for 1 sec
        
    end
  
    %once our frequency array is full, we have to reset
    if idx>12
        freqs = zeros(1,12);    
        idx = 1;                
    end
    
    dur = 4096; %reset duration

end

soundsc(note, 8192) %play it back