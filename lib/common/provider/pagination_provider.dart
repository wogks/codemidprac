import 'package:code_mid/common/model/cursor_pagination_model.dart';
import 'package:code_mid/common/model/model_with_id.dart';
import 'package:code_mid/common/model/pagination_params.dart';
import 'package:code_mid/common/repository/base_pagination_repository.dart';
import 'package:code_mid/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      //바로 반환하는 상황
      //1. hasMore = false(기존 상태에서 이미 다음데이터가 없다는 값을 들고있다)
      //2. 로딩중 - fetchMore:true, fetchMore가 아닐때 새로고침의 의도가 없다
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }
      //페이지네이션 파라미터 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못함');
    }
  }

  // getDetail({required String id}) async {
  //   if (state is! CursorPagination) {
  //     await paginate();
  //   }

  //   if (state is! CursorPagination) {
  //     return;
  //   }

  //   final pState = state as CursorPagination;

  //   final resp = await repository.getRestaurantDetail(id: id);

  //   state = pState.copyWith(
  //       data: pState.data
  //           .map<RestaurantModel>(
  //             (e) => e.id == id ? resp : e,
  //           )
  //           .toList());
  // }
}
