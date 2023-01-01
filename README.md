# is_eat_safe

IsEatSafe est une application qui vous préviens si vos achats sont non conformes.

## Getting Started

## Testing

### Android :
```bash
adb shell cmd jobscheduler run -f com.example.is_eat_safe 999
```
### IOS :
```bash
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.transistorsoft.fetch"]
```