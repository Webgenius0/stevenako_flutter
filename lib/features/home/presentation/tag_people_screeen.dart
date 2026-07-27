import 'package:flutter/material.dart';

// ============================================================
// TagPeopleScreeen — Search + multi-select list of people to tag.
// Matches the provided design 1:1.
// (Class name kept exactly as given, typo and all, so it stays
// a drop-in replacement for your existing stub.)
// ============================================================

class _Person {
  final String id;
  final String name;
  final String handle;
  final List<Color> avatarGradient;

  const _Person({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarGradient,
  });
}

class TagPeopleScreeen extends StatefulWidget {
  final Set<String> initiallyTaggedIds;

  const TagPeopleScreeen({super.key, this.initiallyTaggedIds = const {}});

  @override
  State<TagPeopleScreeen> createState() => _TagPeopleScreeenState();
}

class _TagPeopleScreeenState extends State<TagPeopleScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardColor = Color(0xFF1A1926);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);

  final TextEditingController _searchController = TextEditingController();
  late Set<String> _selectedIds;
  String _query = '';

  // TODO: Replace with real people from your backend/contacts/follow graph.
  final List<_Person> _people = const [
    _Person(
      id: 'alexm',
      name: 'Alex Morgan',
      handle: '@alexm',
      avatarGradient: [Color(0xFFB16CFF), Color(0xFF7C3AED)],
    ),
    _Person(
      id: 'jordanl',
      name: 'Jordan Lee',
      handle: '@jordanl',
      avatarGradient: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    ),
    _Person(
      id: 'samr',
      name: 'Sam Rivera',
      handle: '@samr',
      avatarGradient: [Color(0xFF7C6CFF), Color(0xFF4C3AED)],
    ),
    _Person(
      id: 'taylork',
      name: 'Taylor Kim',
      handle: '@taylork',
      avatarGradient: [Color(0xFFEC4899), Color(0xFFBE185D)],
    ),
    _Person(
      id: 'caseyc',
      name: 'Casey Chen',
      handle: '@caseyc',
      avatarGradient: [Color(0xFFD946EF), Color(0xFF9333EA)],
    ),
    _Person(
      id: 'rileyp',
      name: 'Riley Park',
      handle: '@rileyp',
      avatarGradient: [Color(0xFF9F5CFF), Color(0xFF6D28D9)],
    ),
    _Person(
      id: 'morganw',
      name: 'Morgan West',
      handle: '@morganw',
      avatarGradient: [Color(0xFF7C6CFF), Color(0xFF5B21B6)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initiallyTaggedIds};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Person> get _filteredPeople {
    if (_query.trim().isEmpty) return _people;
    final q = _query.toLowerCase();
    return _people
        .where((p) =>
    p.name.toLowerCase().contains(q) ||
        p.handle.toLowerCase().contains(q))
        .toList();
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _onBack() {
    // Return the selected people to the caller (e.g. the Post screen).
    Navigator.of(context).maybePop(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final people = _filteredPeople;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 30),
                    ),
                    const Expanded(
                      child: Text(
                        'Tag People',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44), // balances the back button
                  ],
                ),
              ),

              // ---- Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: _cardBorder),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: _hintColor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search people...',
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ---- People list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: people.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final person = people[index];
                    final isSelected = _selectedIds.contains(person.id);
                    return _PersonRow(
                      person: person,
                      isSelected: isSelected,
                      onTap: () => _toggle(person.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Reusable row
// ============================================================

class _PersonRow extends StatelessWidget {
  final _Person person;
  final bool isSelected;
  final VoidCallback onTap;

  const _PersonRow({
    required this.person,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: _cardBorder),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: person.avatarGradient,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  person.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name + handle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      person.handle,
                      style: const TextStyle(
                        color: _hintColor,
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? _purple : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? _purple : _cardBorder,
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                  width: 11,
                  height: 11,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}