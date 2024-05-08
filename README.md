# 3D 모델 렌더링 for "only mobile"
<img align="right" src="https://github.com/calculus12/flutter_3d_model_rendering/assets/55823958/1748b025-638a-4655-8206-441159aeeeb5" width="25%"></span>

[webveiw_flutter](https://pub.dev/packages/webview_flutter)에서 [\<model-viewer\>](https://modelviewer.dev/)자바스크립트 모듈을 활용하여 3D 모델을 렌더링하는 위젯입니다.

로컬 에셋 디렉토리(/assets/model/)에 저장한 .glb 혹은 .gltf 포맷의 3D 모델을 렌더링합니다.

### Get Started
- `/lib/widget/` 디렉토리 내에 있는 모든 파일 dart파일 및 `/assets/` 디렉토리에 있는 `template.html`, `model-viewer.min.js`가 해당 프로젝트의 경로와 같은 경로에 위치해야 합니다.
- `ModelWidget` 위젯의 `src` 파라미터에 `assets/model/` 디렉토리에 있는 `.glb` 혹은 `.gltf` 포맷의 3D 모델 파일의 식별자를 전달합니다.
- 아래와 같이 `SizedBox` 혹은 `Container` 등과 같이 사이즈를 지정할 수 있는 위젯에 래핑해서 사용합니다.
```dart
// /lib/main.dart
class FirstScreen extends StatelessWidget {
  const FirstScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D model rendering TEST"),),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height*0.9,
        child:ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.7,
            child: const ModelWidget(
              src: 'lancer.glb',
              shadowIntensity: 1,
              shadowSoftness: 1,
            )),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondScreen()));
          }, child: const Text("Go to SecondScreen"))
        ],
      ))
      );
  }
}
```

### reference
- https://github.com/calculus12/model_viewer_plus.dart
