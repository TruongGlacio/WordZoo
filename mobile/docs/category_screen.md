# Category Screen

## Mục đích
Màn hình `CategoryScreen` hiển thị danh sách các nhóm kiến thức chính (category) dưới dạng bảng biển chỉ dẫn (signpost) được đặt ngẫu nhiên trên nền hình ảnh, giúp trẻ em dễ dàng khám phá và chọn lĩnh vực muốn học.

## Cấu trúc dữ liệu

### Category
```dart
class Category {
  final String id;
  final CategoryType type;
  final LocalizedNames names;
  final String icon;
  final String background;
  final String signpostStyle;
  final List<Subcategory> subcategories;
}
```

### CategoryType
App hỗ trợ 4 category chính:
- `animals` - Động vật
- `plants` - Thực vật
- `vehicles` - Phương tiện
- `humanRelations` - Quan hệ con người

## Các Category và Subcategory

### 1. Animals (Động vật)
Các subcategory có thể bao gồm:
- **Wild Animals** - Động vật hoang dã (lion, elephant, tiger, giraffe...)
- **Farm Animals** - Động vật trang trại (cow, pig, sheep, chicken...)
- **Birds** - Chim (parrot, eagle, owl, penguin...)
- **Sea Animals** - Động vật biển (dolphin, shark, whale, octopus...)
- **Insects** - Côn trùng (butterfly, bee, ant, beetle...)
- **Reptiles** - Bò sát (snake, lizard, turtle, crocodile...)
- **Amphibians** - Lưỡng cư (frog, toad, salamander...)
- **Mammals** - Động vật có vú (dog, cat, horse, rabbit...)
- **Fish** - Cá (salmon, tuna, clownfish, seahorse...)
- **Dinosaurs** - Khủng long (T-Rex, Triceratops, Stegosaurus...)
- **Arachnids** - Nhện/bọ cạp (spider, scorpion, tick...)
- **Rodents** - Gặm nhấm (mouse, hamster, squirrel, guinea pig...)
- **Nocturnal Animals** - Động vật hoạt động ban đêm (bat, owl, firefly...)
- **Baby Animals** - Động vật con (puppy, kitten, cub, chick...)
- **Animal Homes** - Nhà của động vật (burrow, nest, den, hive...)

### 2. Plants (Thực vật)
Các subcategory có thể bao gồm:
- **Flowers** - Hoa (rose, sunflower, lotus, tulip...)
- **Trees** - Cây (oak, pine, bamboo, mango...)
- **Fruits** - Trái cây (apple, banana, mango, grape...)
- **Vegetables** - Rau củ (carrot, tomato, potato, corn...)
- **Herbs** - Thảo mộc (basil, mint, rosemary, thyme...)
- **Mushrooms** - Nấm (mushroom, truffle, oyster mushroom...)
- **Cacti** - Xương rồng
- **Vines** - Dây leo (ivy, grapevine, morning glory...)
- **Ferns** - Dương xỉ
- **Palms** - Cây cọ
- **Grasses** - Cỏ (wheat, bamboo grass, rice, corn stalk...)
- **Weeds** - Cỏ dại (dandelion, clover, thistle...)
- **Seeds** - Hạt giống (bean seed, sunflower seed, nut...)
- **Leaves** - Lá (maple leaf, fern leaf, palm leaf...)
- **Roots** - Rễ (carrot root, radish, sweet potato...)

### 3. Vehicles (Phương tiện)
Các subcategory có thể bao gồm:
- **Land Vehicles** - Phương tiện trên đất (car, bus, train, bike...)
- **Water Vehicles** - Phương tiện trên nước (boat, ship, submarine...)
- **Air Vehicles** - Phương tiện trên không (airplane, helicopter, balloon...)
- **Construction Vehicles** - Xe công trình (excavator, crane, bulldozer...)
- **Emergency Vehicles** - Xe khẩn cấp (ambulance, fire truck, police car...)
- **Bicycles** - Xe đạp
- **Motorcycles** - Xe máy
- **Trains** - Tàu hỏa
- **Rockets** - Tên lửa
- **Spaceships** - Tàu vũ trụ
- **Scooters** - Xe tay ga / scooter
- **Trucks** - Xe tải (pickup, dump truck, cargo truck...)
- **Boats** - Thuyền nhỏ (canoe, kayak, rowboat...)
- **Ferries** - Phà
- **Hoverboards** - Ván bay / hoverboard

### 4. Human Relations (Quan hệ con người)
Các subcategory có thể bao gồm:
- **Family** - Gia đình (father, mother, brother, sister...)
- **Friends** - Bạn bè (friend, classmate, neighbor...)
- **Community** - Cộng đồng (teacher, doctor, police, firefighter...)
- **Emotions** - Cảm xúc (happy, sad, angry, excited...)
- **Actions** - Hành động (running, jumping, eating, sleeping...)
- **Body Parts** - Bộ phận cơ thể (head, hand, foot, heart...)
- **Senses** - Giác quan (see, hear, smell, taste, touch...)
- **Daily Activities** - Hoạt động hàng ngày (wake up, brush teeth, go to school...)
- **School** - Trường học (classroom, teacher, student, book...)
- **Health** - Sức khỏe (exercise, sleep, doctor, medicine...)
- **Clothes** - Quần áo (shirt, pants, dress, hat...)
- **Food** - Đồ ăn (rice, bread, egg, soup...)
- **Drinks** - Đồ uống (water, juice, milk, tea...)
- **Toys** - Đồ chơi (ball, doll, puzzle, blocks...)
- **Tools** - Công cụ (hammer, screwdriver, scissors, ruler...)

## Luồng điều hướng

```
HomeScreen
  ↓ (tap category card)
CategoryScreen
  ↓ (tap signpost)
EntityListScreen
  ↓ (tap entity)
DetailPanel
```

## UI/UX Behavior

### Background
- Sử dụng hình ảnh nền theo từng category (`category.background`)
- Overlay gradient để đảm bảo text dễ đọc

### Signposts
- Mỗi subcategory được hiển thị dưới dạng `SignpostWidget`
- Vị trí signpost được random dựa trên `sub.id.hashCode` để cố định vị trí
- Kích thước mỗi signpost: 160x80
- Màu: `AppColors.earthBrown`
- Font: `AppTextStyles.signpost`

### Animations
- Signpost có animation scale 200ms khi xuất hiện

## Technical Implementation

### File
- `lib/presentation/screens/category_screen.dart`

### Dependencies
- `dart:math` - Random positioning
- `package:gap/gap.dart` - Spacing
- `package:wordzoo/presentation/widgets/signpost_widget.dart` - Signpost widget

### State Management
- Nhận `Category` object qua constructor
- Không sử dụng BLoC state, chỉ render từ props

### Navigation
- Tap signpost → `Navigator.push` đến `EntityListScreen`
- Back button → `Navigator.pop(context)`

## Responsive
- Landscape locked
- SafeArea để tránh notch/status bar
- Random positioning dựa trên `MediaQuery` để fit mọi kích thước màn hình
