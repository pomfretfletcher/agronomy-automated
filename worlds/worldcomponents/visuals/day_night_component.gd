extends CanvasModulate

@export var spring_gradient: GradientTexture1D
@export var summer_gradient: GradientTexture1D
@export var autumn_gradient: GradientTexture1D
@export var winter_gradient: GradientTexture1D

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connects internal decision function to time passed signal
# Debug - N/A
func _ready() -> void:
	TimeManager.minute_passed_with_parameters.connect(DecideSkyColor)

@warning_ignore("unused_parameter")
func DecideSkyColor(day: int, hour: int, minute: int) -> void:
	# Change screen gradient color based on current time
	var sample_value = sin((float(hour * 60 + minute) / Constants.MINUTES_PER_DAY) * PI)
	color = spring_gradient.gradient.sample(sample_value)
