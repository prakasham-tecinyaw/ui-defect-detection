*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Library    core/UIComparisonLibrary.py

*** Variables ***
${URL}                https://medium.com/datadriveninvestor/i-used-openais-o1-model-to-develop-a-trading-strategy-it-is-destroying-the-market-576a6039e8fa
${BROWSER}            Chrome
${SCREENSHOT_DIR}     screenshots/
${BASE_IMAGE}         ${SCREENSHOT_DIR}base_image.png
${NEW_IMAGE}          ${SCREENSHOT_DIR}new_image_${timestamp}.png
${OUTPUT_WITH_BBOXES} ${SCREENSHOT_DIR}output_with_bboxes_${timestamp}.png

*** Test Cases ***
UI Defect Detection On Medium
    [Documentation]    Navigate to Medium, capture screenshots, and detect UI defects.
    Create Directory    ${SCREENSHOT_DIR}
    
    # Get current timestamp for unique screenshot names
    ${timestamp} =    Get Current Date    result_format=%Y%m%d_%H%M%S
    Set Suite Variable    ${NEW_IMAGE}    ${SCREENSHOT_DIR}new_image_${timestamp}.png
    Set Suite Variable    ${OUTPUT_WITH_BBOXES}    ${SCREENSHOT_DIR}output_with_bboxes_${timestamp}.png

    # Step 1: Open Medium's landing page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5  # Wait for the page to load

    # Step 2: Check if base image exists
    ${exists}=    Run Keyword And Return Status    File Should Exist    ${BASE_IMAGE}

    # Step 3: If base image does not exist, capture it
    Run Keyword If    not ${exists}    Capture Page Screenshot    ${BASE_IMAGE}

    # Step 4: Capture a new image if base image exists
    Run Keyword If    ${exists}    Capture Page Screenshot    ${NEW_IMAGE}

    # Step 5: Perform image comparison if base image exists
    Run Keyword If    ${exists}    Compare Screenshots    ${BASE_IMAGE}    ${NEW_IMAGE}    ${OUTPUT_WITH_BBOXES}

    # Log results
    Log    Comparison complete. Check ${OUTPUT_WITH_BBOXES} for differences.

    Close Browser

*** Keywords ***
Scroll Down
    [Documentation]    Scrolls down the page to trigger potential UI changes.
    Execute JavaScript    window.scrollBy(0, 1000)