# utils.py
import numpy as np
from sklearn.neighbors import KNeighborsClassifier

# Example training dataset
# Features: [price_level, dosage_length]
X_train = np.array([
    [1, 5],   # cheap + short dosage name
    [1, 4],
    [3, 10],  # expensive + long dosage name
    [3, 12],
    [2, 7],   # medium + mid dosage
    [2, 6],
])

y_train = ["low", "low", "high", "high", "medium", "medium"]

knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(X_train, y_train)


def predict_group(cost_status: str, dosage_form: str) -> str:
    """
    Mock AI tool to predict group for a Pharmacy product.
    Uses cost_status (low/medium/high) + dosage_form length.
    """
    cost_map = {"low": 1, "medium": 2, "high": 3}
    features = np.array([[cost_map.get(cost_status, 2), len(dosage_form or "")]])
    return knn.predict(features)[0]
