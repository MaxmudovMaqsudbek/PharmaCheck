from django.db import models
import uuid
import hashlib
import time
from .utils import predict_group
from django.contrib.auth.models import Group


class Block(models.Model):
    index = models.IntegerField()
    timestamp = models.FloatField()
    data = models.TextField()  # pharmacy UUID or details
    previous_hash = models.CharField(max_length=64)
    hash = models.CharField(max_length=64)

    def save(self, *args, **kwargs):
        """Calculate hash before saving"""
        if not self.hash:  # only if hash not already set
            block_string = f"{self.index}{self.timestamp}{self.data}{self.previous_hash}"
            self.hash = hashlib.sha256(block_string.encode()).hexdigest()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Block {self.index} - {self.hash[:10]}..."


class Group(models.Model):
    name = models.CharField(max_length=20)

    def __str__(self):
        return f"{self.name}"

from django.db import models
import uuid
from .utils import predict_group
from django.contrib.auth.models import Group  # assuming your Group is Django's or custom

# class Pharmacy(models.Model):
#     uuid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
#     name = models.CharField(max_length=255)
#     brand = models.CharField(max_length=255, blank=True, null=True)
#     brandCertLink = models.URLField(blank=True, null=True)
#     brandLicenceLink = models.URLField(blank=True, null=True)
#     dosageForm = models.CharField(max_length=100, blank=True, null=True)
#     strength = models.CharField(max_length=100, blank=True, null=True)
#     activeingredients = models.JSONField(blank=True, null=True, help_text="List of active ingredients as JSON list")
#     gtin = models.CharField(max_length=14, blank=True, null=True, unique=True)
#     batch = models.CharField(max_length=100, blank=True, null=True)
#     manufactureDate = models.DateField(blank=True, null=True)
#     expiryDate = models.DateField(blank=True, null=True)
#     StorageConditions = models.TextField(blank=True, null=True)
#     regulatoryInfo = models.TextField(blank=True, null=True)
#     imageExample = models.ImageField(upload_to='pharmacy_images/', blank=True, null=True)
#     is_read = models.BooleanField(default=False)
#     cost_status = models.CharField(
#         max_length=10,
#         choices=[
#             ("low", "Low"),
#             ("medium", "Medium"),
#             ("high", "High"),
#         ],
#         default='medium'
#     )
#     group = models.ForeignKey(Group, on_delete=models.SET_NULL, null=True, blank=True)
#
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)
#
#     class Meta:
#         ordering = ['-created_at']
#
#     def __str__(self):
#         return f"{self.name} ({self.brand or 'no-brand'})"
#
#     def save(self, *args, **kwargs):
#         # 🧠 AI auto-assign group if not set manually
#         if not self.group:
#             predicted_group_name = predict_group(self.cost_status, self.dosageForm or "")
#             group_obj, _ = Group.objects.get_or_create(name=predicted_group_name)
#             self.group = group_obj
#         super().save(*args, **kwargs)
class Pharmacy(models.Model):
    uuid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    brand = models.CharField(max_length=255, blank=True, null=True)
    brandCertLink = models.URLField(blank=True, null=True)
    brandLicenceLink = models.URLField(blank=True, null=True)
    dosageForm = models.CharField(max_length=100, blank=True, null=True)
    strength = models.CharField(max_length=100, blank=True, null=True)
    activeingredients = models.JSONField(blank=True, null=True, help_text="List of active ingredients as JSON list")
    gtin = models.CharField(max_length=14, blank=True, null=True, unique=True)
    batch = models.CharField(max_length=100, blank=True, null=True)
    manufactureDate = models.DateField(blank=True, null=True)
    expiryDate = models.DateField(blank=True, null=True)
    StorageConditions = models.TextField(blank=True, null=True)
    regulatoryInfo = models.TextField(blank=True, null=True)
    imageExample = models.ImageField(upload_to='pharmacy_images/', blank=True, null=True)
    is_read = models.BooleanField(default=False)
    cost_status = models.CharField(
        max_length=10,
        choices=[
            ("low", "Low"),
            ("medium", "Medium"),
            ("high", "High"),
        ],
        default='medium'
    )
    group = models.ForeignKey(Group, on_delete=models.SET_NULL, null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name} ({self.brand or 'no-brand'})"

    def save(self, *args, **kwargs):
        # 🧠 AI auto-assign group if not set manually
        if not self.group:
            predicted_group_name = predict_group(self.cost_status, self.dosageForm or "")
            group_obj, _ = Group.objects.get_or_create(name=predicted_group_name)
            self.group = group_obj
        super().save(*args, **kwargs)
