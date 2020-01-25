import processing.video.*;
import mqtt.*;
import java.util.HashMap;
import java.util.Map;
import java.lang.Runtime;

MQTTClient client;
HashMap<String, Video> videos = new HashMap<String, Video>();
String currentVideo;

public class Video {
  String fileName;
  boolean isLoop;
  Movie movie;

  public Video(String fileName, boolean isLoop) {
    this.fileName = fileName;
    this.isLoop = isLoop;
  }
}

void setup() {
  try {
    Runtime.getRuntime().exec("launchctl start homebrew.mxcl.mosquitto");
  }
  catch (IOException e) {
    //Failed to run command
  }

  videos.put("triggerVideoMain", new Video("trees.mp4", true)); //Sample video files. Replace with the filenames of videos in the same folder as the sketch.
  videos.put("triggerVideoFail", new Video("tunnel.mp4", true));
  videos.put("triggerVideoWin", new Video("transit.mov", true));
  videos.put("triggerVideoHUD", new Video("hud.mp4", true));
  videos.put("triggerVideoRed", new Video("redparticles.mp4", true));

  currentVideo = "triggerMainVideo";
  println("Starting video: " + currentVideo);
  fullScreen(P2D);
  background(0);
  // Create "movies" for all of the videos in the HashMap
  for (Map.Entry<String, Video> entry : videos.entrySet()) {
    entry.getValue().movie = new Movie(this, entry.getValue().fileName);
  }
  client = new MQTTClient(this);
  client.connect("mqtt://10.102.192.238:1883", "processing"); //Replace with your IP address.
}

void clientConnected() {
  println("client connected");
  client.subscribe("topic/state");
}

void messageReceived(String topic, byte[] payload) {
  String msg = new String(payload);
  if (videos.containsKey(msg)) {
    currentVideo = msg;
    println("Triggering: " + msg);
  } else if (msg.equals("blackScreen")) {
    background(0);
  } else {
    println("Ignoring invalid msg: " + msg);
  }
}

void playVideo(String vidKey) {
  for (Map.Entry<String, Video> entry : videos.entrySet()) {
    if (entry.getKey().equals(vidKey)) {
      //Start playing the selected video.
      entry.getValue().movie.loop();
      image(entry.getValue().movie, 0, 0, width, height);
    } else {
      //Stop looping all videos
      entry.getValue().movie.noLoop();
      entry.getValue().movie.stop();
    }
  }
}

void connectionLost() {
  println("connection lost");
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  playVideo(currentVideo);
}
