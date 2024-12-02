#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * **AudioPlayer Structure**
 * The AudioPlayer structure is a Rust implementation of an audio player that provides a simple and efficient way to play audio files.
 *
 * This structure is designed to be thread-safe, allowing multiple threads to access and control the audio player simultaneously.
 * It also supports real-time volume control, enabling dynamic adjustments to the audio volume during playback.
 *
 * The AudioPlayer structure provides a range of methods for playing audio files, controlling playback, and managing audio settings.
 * It is built on top of the cpal library, which provides a cross-platform audio API for Rust.
 *
 * **Key Features**:
 *
 * * Thread-safe design for concurrent access and control
 * * Real-time volume control for dynamic adjustments
 * * Support for playing audio files in various formats
 * * Simple and efficient API for playback control and audio management
 */
typedef struct AudioPlayer AudioPlayer;

typedef struct SoundConfig SoundConfig;

struct AudioPlayer *audio_player_new(float initial_volume);

void audio_player_audio_play(struct AudioPlayer *player, struct SoundConfig *config);

void audio_player_audio_volume_control(struct AudioPlayer *player, float new_volume);

void audio_player_free(struct AudioPlayer *player);

struct SoundConfig *sound_config_new(uint32_t frequency,
                                     int32_t ear,
                                     uint32_t dbr,
                                     bool fixed_volume);

void sound_config_free(struct SoundConfig *config);
