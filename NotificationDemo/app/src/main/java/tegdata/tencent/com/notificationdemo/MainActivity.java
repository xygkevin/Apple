package tegdata.tencent.com.notificationdemo;

import android.app.Notification;
import android.app.NotificationChannelGroup;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

public class MainActivity extends AppCompatActivity {

    private int notificationID = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void createNotification(View v) {
        final NotificationCompat.Builder builder = new NotificationCompat.Builder(this)
//                .setContentTitle("Fuck Notification")
//                .setContentText("This is my first Android Notification")
                .setSmallIcon(R.mipmap.ic_launcher) // this is required for notification in the status bar
//                .setWhen(System.currentTimeMillis() + 3600000)
//                .setOngoing(true)
//                .setTicker("this is state text")
//                .setSubText("this is sub")
                .setDefaults(NotificationCompat.DEFAULT_SOUND)
                .setVibrate(new long[]{0, 1000, 1000});

        RemoteViews remoteViews = new RemoteViews(getPackageName(), R.layout.notitication_message);
        remoteViews.setTextViewText(R.id.message_title, "This is Custom View");
        builder.setContent(remoteViews);



//        NotificationCompat.InboxStyle inboxStyle = new NotificationCompat.InboxStyle();
//        String events[] = {"a","b","c","d","e","f","g"};
//        inboxStyle.setBigContentTitle("XXXXXXXX");
//        for (int i = 0; i < events.length; i++){
//            inboxStyle.addLine(events[i]);
//        }
//
//        builder.setStyle(inboxStyle);

        // open the activity and then you can back to main activity
//        Intent resultIntent = new Intent(this, ResultActivity.class);
//        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
//        stackBuilder.addParentStack(ResultActivity.class);
//        stackBuilder.addNextIntent(resultIntent);
//        PendingIntent pendingIntent = stackBuilder.getPendingIntent(0,PendingIntent.FLAG_UPDATE_CURRENT);
//        builder.setContentIntent(pendingIntent);

        // not back to main activity
        Intent singleIntent = new Intent(this, SingleActivity.class);
        singleIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,0,singleIntent, 0);
        builder.setContentIntent(pendingIntent);


        final NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);

        final Notification notification = builder.build();
        notification.flags = Notification.FLAG_AUTO_CANCEL;
        builder.setDefaults(Notification.DEFAULT_ALL);
        builder.setPriority(Notification.PRIORITY_MAX);

        Intent deleteIntent = new Intent();
        deleteIntent.putExtra("key","testValue");
        deleteIntent.setClass(this,MyReceiver.class);
        deleteIntent.setAction("Delete");
        notification.deleteIntent = PendingIntent.getBroadcast(this,0,deleteIntent,0);


        /*add progress in notification*/
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                int index;
//                for (index = 0; index < 100; index+=10){
//
//                    // Animation until finished with increasing progress
//                    builder.setProgress(100,index, false);
//                    // Animation until finished without increasing progress
//                    builder.setProgress(0,0, true);
//                    notificationManager.notify(0, builder.build());
//                    try {
//                        Thread.sleep(500);
//                    } catch (InterruptedException e) {
//                        Log.i("TAG", "sleep failure");
//                    }
//                }
//                builder.setContentText("Finished!").setProgress(0, 0, false);
//                notificationManager.notify(notificationID, builder.build());
//            }
//        }).start();





        notificationManager.notify(notificationID++, notification);

    }

}
