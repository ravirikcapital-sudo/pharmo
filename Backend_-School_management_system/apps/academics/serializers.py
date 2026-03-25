from rest_framework import serializers
from .models import Subject, SportsGroup, HouseGroup
from apps.schoolclassesmanage.models import SchoolClass
from apps.facilities.models import ClassRoom
from apps.teachers.models import TeacherProfile


class SchoolClassCreateSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=100)
    section = serializers.CharField(
        max_length=10, required=False, allow_blank=True, allow_null=True
    )
    capacity = serializers.IntegerField(required=False, allow_null=True)
    class_teacher = serializers.PrimaryKeyRelatedField(
        queryset=TeacherProfile.objects.all(), required=False, allow_null=True
    )

    def create(self, validated_data):
        capacity = validated_data.pop("capacity", None)
        class_teacher = validated_data.pop("class_teacher", None)

        school_class = SchoolClass.objects.create(
            name=validated_data["name"],
            section=validated_data.get("section"),
            academic_year="2024-25",
        )

        ClassRoom.objects.create(
            school_class=school_class, capacity=capacity, class_teacher=class_teacher
        )

        return school_class


class SubjectCreateUpdateSerializer(serializers.ModelSerializer):
    # WRITE using class name
    class_name = serializers.SlugRelatedField(
        queryset=SchoolClass.objects.all(),
        slug_field="name",
        many=True,
        required=False,
        write_only=True,
    )

    # READ only class names
    classes = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Subject
        fields = [
            "id",
            "name",
            "code",
            "description",
            "class_name",  # input (names)
            "classes",  # output (names)
        ]

    def create(self, validated_data):
        classes = validated_data.pop("class_name", [])

        subject = Subject.objects.create(**validated_data)

        if classes:
            subject.assigned_classes.set(classes)

        return subject

    def update(self, instance, validated_data):
        classes = validated_data.pop("class_name", None)

        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        instance.save()

        if classes is not None:
            instance.assigned_classes.set(classes)

        return instance

    def get_classes(self, obj):
        result = []

        for school_class in obj.assigned_classes.all():
            # 🚨 Absolute safety check
            if not hasattr(school_class, "name"):
                continue

            classroom = getattr(school_class, "classroom", None)

            result.append(
                {
                    "id": school_class.id,
                    "name": school_class.name,
                    "section": school_class.section,
                    "room_number": classroom.room_number if classroom else None,
                    "capacity": classroom.capacity if classroom else None,
                }
            )

        return result


class SubjectDetailSerializer(serializers.ModelSerializer):
    classes = serializers.SerializerMethodField()

    class Meta:
        model = Subject
        fields = [
            "id",
            "name",
            "code",
            "description",
            "credits",
            "classes",
        ]

    def get_classes(self, obj):
        return [
            {
                "id": cls.id,
                "name": cls.name,
                "section": cls.section,
            }
            for cls in obj.assigned_classes.all()
        ]


class AcademicDashboardSerializer(serializers.Serializer):
    total_classes = serializers.IntegerField()
    total_subjects = serializers.IntegerField()
    total_teachers = serializers.IntegerField()
    total_sports_groups = serializers.IntegerField()
    total_house_groups = serializers.IntegerField()


class SportsGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = SportsGroup
        fields = "__all__"


class HouseGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = HouseGroup
        fields = "__all__"
