import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

/// PC端待办页面
/// 设计要点：
/// - 内容整体居中，最大宽度 760，避免宽屏下控件被拉散
/// - 顶部大标题 + 渐变主按钮；分段式胶囊切换（未完成/已完成）替代原生 TabBar
/// - 待办项为圆角卡片：左侧圆形勾选框切换状态，悬停浮起并显示删除按钮
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  static const Color _primary = Color(0xFF1890FF);
  static const Color _primaryDark = Color(0xFF0C6DD6);

  int _selectedTab = 0; // 0: 未完成, 1: 已完成

  // 待办事项列表
  final List<TodoItem> _pendingTodos = [];
  final List<TodoItem> _completedTodos = [];

  @override
  Widget build(BuildContext context) {
    final todos = _selectedTab == 0 ? _pendingTodos : _completedTodos;
    return Container(
      color: const Color(0xFFF0F2F5),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSegmentedTabs(),
            const SizedBox(height: 4),
            Expanded(
              child: todos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return _TodoCard(
                          key: ValueKey(todo.id),
                          todo: todo,
                          isCompleted: _selectedTab == 1,
                          onTap: () =>
                              _showTodoDetailDialog(todo, _selectedTab == 1),
                          onToggle: () => _toggleTodoStatus(todo),
                          onDelete: () => _deleteTodo(todo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 顶部：标题 + 添加按钮
  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.translate('todo'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.5,
              ),
            ),
          ),
          // 渐变添加按钮
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _primaryDark],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showAddTodoDialog,
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 11,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 18, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        l10n.translate('add_todo'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 分段式胶囊切换（未完成/已完成）
  Widget _buildSegmentedTabs() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE4E7EC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildSegment(0, l10n.translate('pending'), _pendingTodos.length),
            _buildSegment(
              1,
              l10n.translate('completed'),
              _completedTodos.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(int index, String label, int count) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? _primary : const Color(0xFF666666),
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _primary.withValues(alpha: 0.12)
                        : const Color(0xFFD5D9E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? _primary
                          : const Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 空状态
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/待办/todoListEmpty.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('no_todo_content'),
            style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  // 显示待办详情对话框
  void _showTodoDetailDialog(TodoItem todo, bool isCompleted) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              // 状态标签
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFF6FFED)
                      : const Color(0xFFE6F4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFFB7EB8F)
                        : const Color(0xFF91CAFF),
                  ),
                ),
                child: Text(
                  isCompleted
                      ? l10n.translate('completed')
                      : l10n.translate('pending'),
                  style: TextStyle(
                    color: isCompleted
                        ? const Color(0xFF52C41A)
                        : _primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.description?.isNotEmpty ?? false) ...[
                  Text(
                    l10n.translate('description'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      todo.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                        height: 1.6,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    l10n.translate('no_description'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.translate('close')),
            ),
          ],
        );
      },
    );
  }

  // 显示添加待办对话框
  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        InputDecoration fieldDecoration(String label) => InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F6F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _primary, width: 1.5),
              ),
            );
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.translate('add_todo'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: fieldDecoration(l10n.translate('title')),
                  autofocus: true,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(fontSize: 13),
                  decoration: fieldDecoration(
                    l10n.translate('description_optional'),
                  ),
                  maxLines: 8,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF666666),
              ),
              child: Text(l10n.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  _addTodo(
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                  );
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.translate('confirm')),
            ),
          ],
        );
      },
    );
  }

  // 添加待办
  void _addTodo(String title, String description) {
    setState(() {
      _pendingTodos.add(
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          description: description.isNotEmpty ? description : null,
          isCompleted: false,
        ),
      );
      _selectedTab = 0; // 新增后切回"未完成"
    });
    // TODO: 保存到服务器
  }

  // 切换待办状态
  void _toggleTodoStatus(TodoItem todo) {
    setState(() {
      if (_pendingTodos.contains(todo)) {
        _pendingTodos.remove(todo);
        _completedTodos.add(todo.copyWith(isCompleted: true));
      } else if (_completedTodos.contains(todo)) {
        _completedTodos.remove(todo);
        _pendingTodos.add(todo.copyWith(isCompleted: false));
      }
    });
    // TODO: 更新到服务器
  }

  // 删除待办
  void _deleteTodo(TodoItem todo) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.translate('confirm_delete')),
          content: Text(l10n.translate('confirm_delete_todo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF666666),
              ),
              child: Text(l10n.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pendingTodos.remove(todo);
                  _completedTodos.remove(todo);
                });
                Navigator.of(context).pop();
                // TODO: 从服务器删除
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D4F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.translate('delete')),
            ),
          ],
        );
      },
    );
  }
}

/// 单个待办卡片：悬停浮起、左侧圆形勾选框、悬停才显示删除按钮
class _TodoCard extends StatefulWidget {
  final TodoItem todo;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoCard({
    super.key,
    required this.todo,
    required this.isCompleted,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<_TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<_TodoCard> {
  static const Color _primary = Color(0xFF1890FF);

  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.isCompleted;
    final l10n = AppLocalizations.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovering ? 0.10 : 0.04),
              blurRadius: _hovering ? 14 : 6,
              offset: Offset(0, _hovering ? 4 : 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // 圆形勾选框：切换完成/未完成
                  Tooltip(
                    message: isCompleted
                        ? l10n.translate('mark_incomplete')
                        : l10n.translate('mark_complete'),
                    child: GestureDetector(
                      onTap: widget.onToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? const Color(0xFF52C41A)
                              : Colors.transparent,
                          border: Border.all(
                            color: isCompleted
                                ? const Color(0xFF52C41A)
                                : (_hovering
                                    ? _primary
                                    : const Color(0xFFC9CDD4)),
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // 标题 + 描述
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.todo.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isCompleted
                                ? const Color(0xFFB0B3B8)
                                : const Color(0xFF1A1A1A),
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: const Color(0xFFB0B3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.todo.description?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.todo.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isCompleted
                                  ? const Color(0xFFCCCCCC)
                                  : const Color(0xFF8A8F99),
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: const Color(0xFFCCCCCC),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 删除按钮：悬停时才显示
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _hovering ? 1.0 : 0.0,
                    child: IconButton(
                      onPressed: _hovering ? widget.onDelete : null,
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Color(0xFFFF4D4F),
                      ),
                      tooltip: l10n.translate('delete'),
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 待办项数据模型
class TodoItem {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
