import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../services/game_engine.dart';
import '../widgets/game_object_widget.dart';
import '../widgets/score_widget.dart';
import '../widgets/title_text_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: SafeArea(
              child: Scaffold(
                body: GetBuilder<GameController>(
                  init: GameControllerImpl(
                    gameEngine: RockPaperScissorsGameEngine(),
                    screenSize: Size(
                      ScreenUtil().screenWidth - 60,
                      ScreenUtil().screenHeight -
                          ScreenUtil().statusBarHeight -
                          60,
                    ),
                  ),
                  builder: (controller) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Update screen size when layout changes
                        controller.updateScreenSize(
                          Size(
                            constraints.maxWidth - 60,
                            constraints.maxHeight - 60,
                          ),
                        );

                        return Obx(() {
                          final state = controller.currentState;

                          return SafeArea(
                            child: Stack(
                              children: [
                                // Title texts
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TitleTextWidget(
                                        text: "Rock!",
                                        color: state.rockTextColor,
                                      ),
                                      TitleTextWidget(
                                        text: "Paper!",
                                        color: state.paperTextColor,
                                      ),
                                      TitleTextWidget(
                                        text: "Scissor!",
                                        color: state.scissorTextColor,
                                      ),
                                    ],
                                  ),
                                ),

                                // Game objects
                                Stack(
                                  children:
                                      state.objects
                                          .map(
                                            (obj) => GameObjectWidget(
                                              gameObject: obj,
                                            ),
                                          )
                                          .toList(),
                                ),

                                // Score display
                                Positioned(
                                  bottom: 5,
                                  left: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ScoreWidget(
                                        emoji: "🪨",
                                        score: state.rocksWins,
                                      ),
                                      const SizedBox(width: 30),
                                      ScoreWidget(
                                        emoji: "📄",
                                        score: state.papersWins,
                                      ),
                                      const SizedBox(width: 30),
                                      ScoreWidget(
                                        emoji: "✂️",
                                        score: state.scissorsWins,
                                      ),
                                    ],
                                  ),
                                ),

                                // Restart button
                                Positioned(
                                  top: 5,
                                  right: 5,

                                  child: IconButton(
                                    onPressed: () {
                                      controller.restartGame();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }
}
