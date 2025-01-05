import cv2
import numpy as np

class UIComparisonLibrary:
    def compare_screenshots(self, base_image_path, new_image_path, output_with_bboxes_path):
        # Load the images
        base_image = cv2.imread(base_image_path)
        new_image = cv2.imread(new_image_path)

        # Convert images to grayscale
        gray_base = cv2.cvtColor(base_image, cv2.COLOR_BGR2GRAY)
        gray_new = cv2.cvtColor(new_image, cv2.COLOR_BGR2GRAY)

        # Compute the absolute difference between the two images
        difference = cv2.absdiff(gray_base, gray_new)

        # Threshold the difference image
        _, thresh = cv2.threshold(difference, 30, 255, cv2.THRESH_BINARY)

        # Find contours in the thresholded image
        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # Draw bounding boxes around the detected contours
        for contour in contours:
            if cv2.contourArea(contour) > 100:  # Filter small contours
                x, y, w, h = cv2.boundingRect(contour)
                cv2.rectangle(new_image, (x, y), (x + w, y + h), (0, 255, 0), 2)  # Green box

        # Save the output image with bounding boxes
        cv2.imwrite(output_with_bboxes_path, new_image)

        # Return the number of differences detected
        return len(contours)