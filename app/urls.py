from django.urls import path
from .views import PharmacyDetailView

urlpatterns = [
    path('<uuid:uuid>/', PharmacyDetailView.as_view(), name='pharmacy-detail'),
]
