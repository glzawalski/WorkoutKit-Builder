# WorkoutBuilder
Sample project leveraging Apple's newest WorkoutKit SDK. As of June 24th 2023 you will need XCode 15 beta and iOS 17 beta simulator to run this project.

<table>
  <tr>
    <th><img src="https://github.com/glzawalski/WorkoutBuilder/assets/19718645/94771f89-184b-4fbf-a660-53c2d1527ad4"></th>
    <th><img src="https://github.com/glzawalski/WorkoutBuilder/assets/19718645/0ac0e64d-639f-4c22-8d55-b393f0ae4a55"></th>
  </tr>
</table>

Project and SDK still in Beta and subject to changes.

To properly utilize this project you need to select an iOS simulator with a paired watchOS simulator (`iPhone 14 + Watch Ultra` for example). Build and run so iOS simulator is fired up and then go to Simulator > File > Open Simulator and select your paired up watchOS simulator. Both should be paired up. If not, then workout previews will not work.

Known issues:
- Trying to create a workout with zero iterations will throw a crash instead of an error like when trying to build a goal with zero as it's value
