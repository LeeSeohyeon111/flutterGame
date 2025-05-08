part of 'room_cubit.dart'; //두개 묶어서 컴파일. 

@immutable //만들어진뒤 절대수정x. 추상상태 정의.
sealed class RoomState extends Equatable { //Equatable:값 같으면 같다고 인식.
  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {}

final class RoomLoaded extends RoomState {
  final Room room;
  RoomLoaded(this.room); //상태 초기화

  @override
  List<Object> get props => [room];
  // Equatable이 상태가 바뀌었는지 판단할 때 비교할 기준입니다.
  // 여기선 room이 바뀌면 다른 상태로 간주합니다.
}

final class RoomLoading extends RoomState {}

final class RoomError extends RoomState {
  final String message;

  RoomError(this.message);
  @override
  List<Object> get props => [message];
}

final class GameLoaded extends RoomState {
  final Room room;
  GameLoaded(this.room);

  @override
  List<Object> get props => [room];
}
