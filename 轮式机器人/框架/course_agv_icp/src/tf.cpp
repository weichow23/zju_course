#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/PoseStamped.h>

int main(int argc, char** argv) {
  ros::init(argc, argv, "my_tf");
  ros::NodeHandle nh;
  tf::StampedTransform tf_stamped;
  tf::TransformBroadcaster tf_broadcaster;
  try{
    tf::TransformListener tf_listener;
    tf_listener.waitForTransform("/map", "/base_footprint", ros::Time(), ros::Duration(10.0));
    tf_listener.lookupTransform("/map", "/base_footprint", ros::Time(0), tf_stamped);
    tf_stamped.frame_id_ = "map";
    tf_stamped.child_frame_id_ = "world_base";
    ros::Rate rate(20);
    while(ros::ok()) {
      tf_stamped.stamp_ = ros::Time::now();
      tf_broadcaster.sendTransform(tf_stamped);
      rate.sleep();
    }
  }
  catch(tf::TransformException& ex) {
    ROS_ERROR("ERROR");
  }
}